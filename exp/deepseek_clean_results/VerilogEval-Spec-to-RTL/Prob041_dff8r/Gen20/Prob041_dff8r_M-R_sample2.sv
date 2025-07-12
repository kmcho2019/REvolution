module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

    // Implement 8 individual D flip-flops
    reg q0, q1, q2, q3, q4, q5, q6, q7;
    
    always @(posedge clk) begin
        q0 <= reset ? 1'b0 : d[0];
    end
    
    always @(posedge clk) begin
        q1 <= reset ? 1'b0 : d[1];
    end
    
    always @(posedge clk) begin
        q2 <= reset ? 1'b0 : d[2];
    end
    
    always @(posedge clk) begin
        q3 <= reset ? 1'b0 : d[3];
    end
    
    always @(posedge clk) begin
        q4 <= reset ? 1'b0 : d[4];
    end
    
    always @(posedge clk) begin
        q5 <= reset ? 1'b0 : d[5];
    end
    
    always @(posedge clk) begin
        q6 <= reset ? 1'b0 : d[6];
    end
    
    always @(posedge clk) begin
        q7 <= reset ? 1'b0 : d[7];
    end
    
    assign q = {q7, q6, q5, q4, q3, q2, q1, q0};

endmodule