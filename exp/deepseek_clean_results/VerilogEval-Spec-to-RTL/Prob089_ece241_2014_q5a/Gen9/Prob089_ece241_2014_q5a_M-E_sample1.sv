module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg start_inverting;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            start_inverting <= 1'b0;
        end else begin
            if (!start_inverting && x) begin
                start_inverting <= 1'b1;
            end
        end
    end
    
    assign z = start_inverting ? ~x : x;

endmodule