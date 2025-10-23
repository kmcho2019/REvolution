module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam ACC1 = 2'b01;
    localparam ACC2 = 2'b10;
    localparam ACC3 = 2'b11;
    
    reg [1:0] state, next_state;
    reg [9:0] accum;
    wire [9:0] next_accum = accum + data_in;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE: next_state = valid_in ? ACC1 : IDLE;
            ACC1: next_state = valid_in ? ACC2 : ACC1;
            ACC2: next_state = valid_in ? ACC3 : ACC2;
            ACC3: next_state = valid_in ? IDLE : ACC3;
            default: next_state = IDLE;
        endcase
    end

    // Accumulation logic
    always @(*) begin
        if (!rst_n) begin
            accum = 10'b0;
        end else if (valid_in) begin
            accum = (state == IDLE) ? data_in : next_accum;
        end
    end

    // Output generation
    assign valid_out = (state == ACC3) && valid_in;

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 10'b0;
        end else begin
            state <= next_state;
            if (valid_out) begin
                data_out <= next_accum;
            end
        end
    end

endmodule