module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // One-hot state encoding
    localparam [2:0] IDLE  = 3'b001;
    localparam [2:0] BYTE1 = 3'b010;
    localparam [2:0] BYTE2 = 3'b100;

    reg [2:0] state;
    reg [23:0] shift_reg;
    reg [1:0] byte_counter;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
            byte_counter <= 2'b0;
            // Only clear shift_reg if not idle to save power
            if (state != IDLE) shift_reg <= 24'bx;
        end else begin
            done <= 1'b0; // Default assignment
            
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        shift_reg[23:16] <= in; // Store first byte
                        state <= BYTE1;
                        byte_counter <= 2'b1;
                    end
                end
                
                BYTE1: begin
                    shift_reg[15:8] <= in; // Store second byte
                    state <= BYTE2;
                    byte_counter <= 2'b2;
                end
                
                BYTE2: begin
                    shift_reg[7:0] <= in; // Store third byte
                    out_bytes <= shift_reg; // Parallel output
                    done <= 1'b1;          // Assert done
                    state <= IDLE;
                    byte_counter <= 2'b0;
                end
                
                default: state <= IDLE;
            endcase
        end
    end

endmodule