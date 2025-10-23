module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 0: A, 1: B
reg [1:0] counter; // counter for clock cycles
reg w_count; // counter for w = 1

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
                    counter <= 1;
                    w_count <= w;
                end
            end
            1: begin // state B
                if (counter < 3) begin
                    counter <= counter + 1;
                    w_count <= w_count + w;
                end else begin
                    counter <= 0;
                    w_count <= 0;
                    if (w_count == 2) begin
                        z <= 1;
                    end else begin
                        z <= 0;
                    end
                    if (s == 0) begin
                        state <= 0;
                    end else begin
                        counter <= 1;
                        w_count <= w;
                    end
                end
            end
        endcase
    end
end

endmodule