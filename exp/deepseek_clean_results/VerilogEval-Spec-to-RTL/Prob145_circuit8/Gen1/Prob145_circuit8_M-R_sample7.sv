module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg a_prev;
reg [1:0] state;

always @(posedge clock) begin
    a_prev <= a;  // Store previous value of a
    
    // Detect rising edge of a
    if (~a_prev && a) begin
        p <= 1'b1;
        state <= 2'b01;  // First cycle of p=1
    end
    else begin
        p <= 1'b0;
        if (state == 2'b01) begin
            state <= 2'b10;  // Second cycle of p=1
            q <= 1'b1;
        end
        else begin
            state <= 2'b00;
            q <= 1'b0;
        end
    end
end

// Handle asynchronous a fall
always @(negedge a) begin
    if (~clock) begin
        p <= 1'b0;
        q <= 1'b0;
        state <= 2'b00;
    end
end

endmodule