module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    wire d0, d1, d2, d3;
    reg q0, q1, q2, q3;
    
    assign d0 = in;
    assign d1 = q0;
    assign d2 = q1;
    assign d3 = q2;
    assign out = q3;
    
    always @(posedge clk) begin
        if (!resetn) q0 <= 1'b0;
        else q0 <= d0;
    end
    
    always @(posedge clk) begin
        if (!resetn) q1 <= 1'b0;
        else q1 <= d1;
    end
    
    always @(posedge clk) begin
        if (!resetn) q2 <= 1'b0;
        else q2 <= d2;
    end
    
    always @(posedge clk) begin
        if (!resetn) q3 <= 1'b0;
        else q3 <= d3;
    end

endmodule