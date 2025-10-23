module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State definitions
    parameter A = 1'b0;
    parameter B = 1'b1;
    
    reg current_state;
    reg shadow_state;
    
    // State transition evaluation (parallel)
    always @(*) begin
        if (current_state == A) begin
            shadow_state = in ? A : B;
        end else begin
            shadow_state = in ? B : A;
        end
    end
    
    // State register update with swap
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= B;
            shadow_state <= B;
        end else begin
            current_state <= shadow_state;
        end
    end
    
    // Output logic
    assign out = (current_state == B);
    
endmodule