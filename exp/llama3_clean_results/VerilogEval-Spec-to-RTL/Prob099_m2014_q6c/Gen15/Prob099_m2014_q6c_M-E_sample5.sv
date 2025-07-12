module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    always @(*) begin
        Y1 = 1'b0; // Initialize Y1 to 0
        Y3 = 1'b0; // Initialize Y3 to 0
        
        case (1'b1) // Use a case statement with a dummy condition to cover all possible current states
            y[0]: begin // Current state is A
                if (~w) begin
                    // Next state is B
                    Y1 = 1'b1;
                end else begin
                    // Next state is A
                end
            end
            
            y[1]: begin // Current state is B
                if (~w) begin
                    // Next state is C
                end else begin
                    // Next state is D
                    Y3 = 1'b1;
                end
            end
            
            y[2]: begin // Current state is C
                if (~w) begin
                    // Next state is E
                end else begin
                    // Next state is D
                    Y3 = 1'b1;
                end
            end
            
            y[3]: begin // Current state is D
                if (~w) begin
                    // Next state is F
                end else begin
                    // Next state is A
                end
            end
            
            y[4]: begin // Current state is E
                if (w) begin
                    // Next state is E
                end else begin
                    // Next state is D
                    Y3 = 1'b1;
                end
            end
            
            y[5]: begin // Current state is F
                if (w) begin
                    // Next state is C
                end else begin
                    // Next state is D
                    Y3 = 1'b1;
                end
            end
            
        endcase
    end

endmodule