module TopModule (
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

initial begin
    state = 0;
    q = 0;
end

always @(posedge clk) begin
    // State transition logic
    if (state == 0) begin
        if (a ^ b) begin
            state <= 1;
        end
    end
    else begin // state == 1
        if (a & b) begin
            state <= 0;
        end
    end

    // q output logic
    if (state == 0) begin
        q <= b;
    end
    // else maintain q value (implicit)
end

endmodule