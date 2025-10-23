module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output done
);

    // One-hot encoded states
    localparam IDLE    = 3'b001;
    localparam RECEIVE = 3'b010;
    localparam STOP    = 3'b100;

    reg [2:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Combinational done signal
    assign done = (state == STOP) & in;

    // State transitions and data processing
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
        end else begin
            // Default assignments
            bit_count <= bit_count;
            out_byte <= out_byte;
            
            case (state)
                IDLE: begin
                    if (!in) begin
                        state <= RECEIVE;
                        bit_count <= 3'b0;
                        shift_reg <= 8'b0;
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};  // LSB first
                    if (bit_count == 3'b111) begin
                        state <= STOP;
                        out_byte <= {in, shift_reg[7:1]};  // Capture final bit
                    end else begin
                        bit_count <= bit_count + 1;
                    end
                end
                
                STOP: begin
                    if (in) begin
                        state <= IDLE;
                    end
                end
                
                default: state <= IDLE;
            endcase
        end
    end

endmodule