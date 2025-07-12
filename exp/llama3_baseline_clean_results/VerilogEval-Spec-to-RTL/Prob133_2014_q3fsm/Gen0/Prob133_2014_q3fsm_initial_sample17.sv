module TopModule(clk, reset, s, w, z);
    input clk, reset, s, w;
    output z;
    reg [1:0] state;
    reg [2:0] count_w;
    reg [1:0] clock_count;
    reg z_reg;

    // Define states
    parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            count_w <= 0;
            clock_count <= 0;
            z_reg <= 0;
        end else begin
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                    end else begin
                        state <= A;
                    end
                end
                B: begin
                    state <= C;
                    count_w <= 0;
                    clock_count <= 1;
                end
                C: begin
                    count_w <= count_w + w;
                    clock_count <= clock_count + 1;
                    if (clock_count == 3) begin
                        state <= D;
                    end else begin
                        state <= C;
                    end
                end
                D: begin
                    z_reg <= (count_w == 2) ? 1 : 0;
                    state <= B;
                    count_w <= 0;
                    clock_count <= 0;
                end
            endcase
        end
    end

    assign z = z_reg;
endmodule