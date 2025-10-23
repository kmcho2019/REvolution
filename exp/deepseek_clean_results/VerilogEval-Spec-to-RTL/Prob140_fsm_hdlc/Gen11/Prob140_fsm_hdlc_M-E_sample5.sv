module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [6:0] history;
    reg error_latched;
    
    always @(posedge clk) begin
        if (reset) begin
            history <= 7'b0;
            disc <= 0;
            flag <= 0;
            err <= 0;
            error_latched <= 0;
        end else begin
            // Clear outputs unless set
            disc <= 0;
            flag <= 0;
            err <= 0;
            
            if (!error_latched) begin
                // Shift in new bit
                history <= {history[5:0], in};
                
                // Pattern detection (all parallel)
                if (history[5:0] == 6'b111110 && in == 0) begin
                    disc <= 1;
                end
                if (history == 7'b0111110) begin
                    flag <= 1;
                end
                if (history == 7'b1111111) begin
                    err <= 1;
                    error_latched <= 1;
                end
            end else begin
                // Stay in error state until reset
                err <= 1;
            end
        end
    end

endmodule