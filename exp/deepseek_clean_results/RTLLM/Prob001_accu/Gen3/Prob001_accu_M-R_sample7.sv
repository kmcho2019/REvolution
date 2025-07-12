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
    localparam ONE  = 2'b01;
    localparam TWO  = 2'b10;
    localparam THREE = 2'b11;

    reg [1:0] state, next_state;
    reg [9:0] accumulator, next_accumulator;
    wire [9:0] sum = accumulator + data_in;

    // Next state and accumulator logic (combinational)
    always @(*) begin
        next_state = state;
        next_accumulator = accumulator;
        valid_out = 1'b0;

        if (valid_in) begin
            case (state)
                IDLE: begin
                    next_state = ONE;
                    next_accumulator = data_in;
                end
                ONE: begin
                    next_state = TWO;
                    next_accumulator = sum;
                end
                TWO: begin
                    next_state = THREE;
                    next_accumulator = sum;
                end
                THREE: begin
                    next_state = IDLE;
                    next_accumulator = 10'b0;
                    valid_out = 1'b1;
                end
            endcase
        end
    end

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            accumulator <= 10'b0;
            data_out <= 10'b0;
        end
        else begin
            state <= next_state;
            accumulator <= next_accumulator;
            
            // Capture output only when we have 4 inputs
            if (state == THREE && valid_in)
                data_out <= sum;
        end
    end

endmodule