module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output reg [9:0] data_out
);

    // State encoding
    localparam IDLE  = 2'b00;
    localparam ACCUM1 = 2'b01;
    localparam ACCUM2 = 2'b10;
    localparam ACCUM3 = 2'b11;
    
    reg [1:0] state, next_state;
    reg [9:0] accum;
    wire [9:0] next_accum = accum + data_in;
    
    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            accum <= 10'b0;
            data_out <= 10'b0;
        end
        else begin
            state <= next_state;
            
            if (valid_in) begin
                case (state)
                    IDLE:   accum <= data_in;
                    ACCUM1: accum <= next_accum;
                    ACCUM2: accum <= next_accum;
                    ACCUM3: begin
                        data_out <= next_accum;
                        accum <= 10'b0;
                    end
                endcase
            end
        end
    end
    
    // Next state logic
    always @(*) begin
        next_state = state;
        if (valid_in) begin
            case (state)
                IDLE:   next_state = ACCUM1;
                ACCUM1: next_state = ACCUM2;
                ACCUM2: next_state = ACCUM3;
                ACCUM3: next_state = IDLE;
            endcase
        end
    end
    
    // Output logic (combinational)
    assign valid_out = (state == ACCUM3) && valid_in;
    
endmodule