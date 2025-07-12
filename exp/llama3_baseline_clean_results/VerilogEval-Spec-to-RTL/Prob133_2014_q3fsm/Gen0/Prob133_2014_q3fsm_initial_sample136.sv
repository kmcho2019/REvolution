module TopModule(
    input  clk,
    input  reset,
    input  s,
    input  w,
    output z
);

enum logic [1:0] {A, B} state, next_state;

logic [1:0] count;
logic w_count;

always_ff @(posedge clk) begin
    if(reset) begin
        state <= A;
        count <= 0;
        w_count <= 0;
        z <= 0;
    end else begin
        case(state)
            A: begin
                if(s) begin
                    state <= B;
                    count <= 0;
                    w_count <= 0;
                    z <= 0;
                end else begin
                    state <= A;
                    z <= 0;
                end
            end
            B: begin
                state <= B;
                if(count == 2) begin
                    if(w_count == 2) begin
                        z <= 1;
                    end else begin
                        z <= 0;
                    end
                    count <= 0;
                    w_count <= 0;
                end else begin
                    if(w) begin
                        w_count <= w_count + 1;
                    end
                    count <= count + 1;
                    z <= 0;
                end
            end
        endcase
    end
end

endmodule