module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [2:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Default outputs remain unchanged unless set
            disc <= 0;
            flag <= 0;
            
            if (in) begin
                if (count < 7) begin
                    count <= count + 1;
                    err <= (count == 6);  // Only set err when transitioning to 7
                end
            end else begin
                // Clear err on 0 input
                err <= 0;
                
                // Set outputs based on count value
                if (count == 5) disc <= 1;
                else if (count == 6) flag <= 1;
                
                count <= 0;
            end
        end
    end

endmodule