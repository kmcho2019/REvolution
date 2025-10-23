module TopModule(clk, reset, s, w, z);
    input clk, reset, s, w;
    output z;
    reg z;
    reg [1:0] state; // 0: state A, 1: state B, initial state A
    reg [1:0] counter; // counter for clock cycles
    reg [1:0] w_count; // counter for occurrences of w

    always @(posedge clk) begin
        if (reset) begin
            state <= 0; // reset to state A
            counter <= 0;
            w_count <= 0;
            z <= 0;
        end else begin
            case (state)
                0: begin // state A
                    if (s) begin
                        state <= 1; // move to state B
                        counter <= 1; // start counting
                        w_count <= 0;
                    end
                end
                1: begin // state B
                    if (counter < 3) begin // within 3 clock cycles
                        counter <= counter + 1;
                        if (w) begin
                            w_count <= w_count + 1;
                        end
                    end else begin // end of 3 clock cycles
                        if (w_count == 2) begin
                            z <= 1; // set z to 1 if exactly two occurrences of w
                        end else begin
                            z <= 0;
                        end
                        counter <= 1; // reset counter
                        w_count <= 0;
                    end
                end
            endcase
        end
    end
endmodule