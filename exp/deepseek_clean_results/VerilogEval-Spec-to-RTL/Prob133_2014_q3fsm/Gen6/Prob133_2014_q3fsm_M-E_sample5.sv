module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State encoding
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;
    
    reg [1:0] state;
    reg [2:0] window_pattern;
    
    // Combinational pattern matching
    wire pattern_match = (window_pattern == 3'b011) || 
                         (window_pattern == 3'b101) || 
                         (window_pattern == 3'b110);
    
    // Output logic
    assign z = (state == D) && pattern_match;
    
    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            window_pattern <= 3'b000;
        end else begin
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        window_pattern <= {2'b00, w};
                    end
                end
                
                B: begin
                    state <= C;
                    window_pattern <= {window_pattern[1:0], w};
                end
                
                C: begin
                    state <= D;
                    window_pattern <= {window_pattern[1:0], w};
                end
                
                D: begin
                    state <= B;
                    window_pattern <= {2'b00, w};
                end
            endcase
        end
    end

endmodule