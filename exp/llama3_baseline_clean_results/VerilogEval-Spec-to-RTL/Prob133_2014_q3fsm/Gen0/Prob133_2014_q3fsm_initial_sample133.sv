module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] state; // 0: State A, 1: State B
reg [1:0] counter; // Counter for clock cycles in State B
reg w_count; // Count of w = 1 in three cycles
reg z_next; // Next value of z

parameter A = 2'b00, B = 2'b01;

always @(posedge clk) begin
    if (reset) begin
        state <= A;
        counter <= 0;
        w_count <= 0;
        z <= 0;
    end else begin
        case (state)
            A: begin
                if (s) begin
                    state <= B;
                    counter <= 1;
                    w_count <= 0;
                end
            end
            B: begin
                if (counter < 3) begin
                    if (w) begin
                        w_count <= w_count + 1;
                    end
                    counter <= counter + 1;
                end else begin
                    if (w_count == 2) begin
                        z <= 1;
                    end else begin
                        z <= 0;
                    end
                    counter <= 1;
                    w_count <= 0;
                    if (w) begin
                        w_count <= 1;
                    end
                end
            end
        endcase
    end
end

endmodule