module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

    // Simplified state encoding
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Combinatorial done signal
    assign done = (state == STOP) && in;

    // Single always block for state and data processing
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            out_byte <= 0;
        end else begin
            case (state)
                IDLE: begin
                    bit_count <= 0;
                    if (!in) begin
                        state <= RECEIVE;
                        shift_reg <= 0;
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};
                    if (bit_count == 7) begin
                        state <= STOP;
                    end
                    bit_count <= bit_count + 1;
                end
                
                STOP: begin
                    if (in) begin
                        out_byte <= shift_reg;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule