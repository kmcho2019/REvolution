module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // FSM states
    localparam IDLE    = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam STOP    = 2'b10;

    reg [1:0] state;
    reg [3:0] bit_count;  // Using bit_count[3] as flag for completion
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 4'b0;
            shift_reg <= 8'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
        end else begin
            // Default assignments
            done <= 1'b0;
            
            case (state)
                IDLE: begin
                    bit_count <= 4'b0;
                    if (in == 1'b0) begin
                        state <= RECEIVE;
                    end
                end
                
                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};  // LSB first
                    bit_count <= bit_count + 1;
                    
                    if (bit_count[3]) begin  // Equivalent to bit_count == 7
                        state <= STOP;
                    end
                end
                
                STOP: begin
                    if (in == 1'b1) begin  // Valid stop bit
                        out_byte <= shift_reg;
                        done <= 1'b1;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule