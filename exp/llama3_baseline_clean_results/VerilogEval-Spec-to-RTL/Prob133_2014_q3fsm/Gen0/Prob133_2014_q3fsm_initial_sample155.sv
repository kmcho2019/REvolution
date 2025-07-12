module TopModule(
    input  clk,
    input  reset,
    input  s,
    input  w,
    output z
);

reg [1:0] state; // 0: State A, 1: State B
reg [1:0] count; // counter for 3 clock cycles
reg [1:0] w_count; // counter for w = 1
reg z_reg; // register for output z

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // reset to state A
        count <= 0;
        w_count <= 0;
        z_reg <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1; // transition to state B
                end
            end
            1: begin // State B
                if (count == 3) begin
                    if (w_count == 2) begin
                        z_reg <= 1; // set z to 1 if w_count == 2
                    end else begin
                        z_reg <= 0; // set z to 0 otherwise
                    end
                    count <= 0; // reset counter
                    w_count <= 0; // reset w_count
                end else begin
                    count <= count + 1; // increment counter
                    if (w) begin
                        w_count <= w_count + 1; // increment w_count if w = 1
                    end
                end
            end
        endcase
    end
end

assign z = z_reg;

endmodule