module TopModule(
    input clk,
    input w,  // input from previous stage
    input R,  // value to load
    input E,  // enable shift
    input L,  // load signal
    output reg Q  // output of the module
);

always @(posedge clk) begin
    if (L) begin
        Q <= R;  // load value when L is asserted
    end else if (E) begin
        Q <= w;  // shift value from previous stage when E is asserted
    end else begin
        Q <= Q;  // hold current value when neither L nor E is asserted
    end
end

endmodule