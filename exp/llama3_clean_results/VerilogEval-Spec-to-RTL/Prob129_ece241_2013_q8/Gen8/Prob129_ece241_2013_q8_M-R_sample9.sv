module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

reg [1:0] state;

// Asynchronous reset
always @(negedge aresetn) begin
    state <= 2'b00;
end

// State machine update
always @(posedge clk) begin
    if (state == 2'b00) begin
        if (x) begin
            state <= 2'b01;
        end
    end else if (state == 2'b01) begin
        if (x) begin
            state <= 2'b10;
        end else begin
            state <= 2'b00;
        end
    end else if (state == 2'b10) begin
        if (x) begin
            state <= 2'b10;
        end else begin
            state <= 2'b01;
        end
    end
end

// Output logic
assign z = (state == 2'b10) && x;

endmodule