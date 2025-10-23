module TopModule(clk, w, R, E, L, Q);
    input clk, w, R, E, L;
    output Q;
    reg Q;

    always @(posedge clk) begin
        if (L) begin
            Q <= R;
        end else if (E) begin
            Q <= w;
        end else begin
            // No change, retain current value
        end
    end
endmodule