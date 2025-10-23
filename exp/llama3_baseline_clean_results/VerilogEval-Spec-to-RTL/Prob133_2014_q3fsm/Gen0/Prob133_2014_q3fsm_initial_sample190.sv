module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output z
);

reg [1:0] state; // 0: state A, 1: state B, 2: not needed, we use a counter instead
reg [1:0] counter; // counts up to 3
reg w_count; // counts the number of w = 1 in 3 cycles

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        counter <= 0;
        w_count <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // state A
                if (s) begin
                    state <= 1;
                    counter <= 1; // start counting from 1 to avoid 0
                    w_count <= 0;
                end
            end
            1: begin // state B
                if (counter < 3) begin
                    if (w)
                        w_count <= w_count + 1;
                    counter <= counter + 1;
                end else begin
                    z <= (w_count == 2) ? 1 : 0;
                    counter <= 1; // reset counter
                    w_count <= 0;
                    if (w)
                        w_count <= w_count + 1;
                end
            end
        endcase
    end
end

endmodule