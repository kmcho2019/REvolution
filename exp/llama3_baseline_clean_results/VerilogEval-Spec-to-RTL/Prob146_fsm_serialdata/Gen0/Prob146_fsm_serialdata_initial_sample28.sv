module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg [2:0] state;
reg [3:0] counter;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // Idle state
        counter <= 0;
        out_byte_reg <= 0;
        done_reg <= 0;
    end
    else begin
        case (state)
            3'b000: // Idle state
                begin
                    if (~in) begin // Start bit detected
                        state <= 3'b001; // Start state
                    end
                end
            3'b001: // Start state
                begin
                    state <= 3'b010; // Receive state
                    counter <= 1;
                    out_byte_reg <= {7'b0, in};
                end
            3'b010: // Receive state
                begin
                    if (counter < 8) begin
                        counter <= counter + 1;
                        out_byte_reg <= {out_byte_reg[6:0], in};
                    end
                    else begin
                        if (in) begin // Stop bit detected
                            state <= 3'b000; // Idle state
                            done_reg <= 1;
                        end
                        else begin
                            state <= 3'b011; // Error state
                        end
                    end
                end
            3'b011: // Error state
                begin
                    if (in) begin // Stop bit detected
                        state <= 3'b000; // Idle state
                    end
                end
            default: ;
        endcase
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

always @(posedge clk) begin
    if (done_reg) begin
        done_reg <= 0;
    end
end

endmodule