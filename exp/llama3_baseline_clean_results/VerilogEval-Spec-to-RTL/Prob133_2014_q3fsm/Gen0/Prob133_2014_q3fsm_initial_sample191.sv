module TopModule(
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

reg [1:0] state; // state A = 2'b00, state B = 2'b01
reg [1:0] counter; // counter for 3 clock cycles
reg w_count; // count the number of times w = 1

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // reset to state A
        counter <= 2'b00;
        w_count <= 1'b0;
        z <= 1'b0;
    end else begin
        case(state)
            2'b00: begin // state A
                if (s) begin
                    state <= 2'b01; // move to state B
                    counter <= 2'b00;
                    w_count <= 1'b0;
                end
            end
            2'b01: begin // state B
                if (counter == 2'b11) begin // 3 clock cycles have passed
                    if (w_count == 2'b10) begin // w = 1 in exactly two clock cycles
                        z <= 1'b1;
                    end else begin
                        z <= 1'b0;
                    end
                    counter <= 2'b00; // reset counter
                    w_count <= 1'b0; // reset w_count
                end else begin
                    if (w) begin
                        w_count <= w_count + 1'b1;
                    end
                    counter <= counter + 1'b1;
                end
            end
        endcase
    end
end

endmodule