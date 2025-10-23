module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [2:0] count;
    reg disc_next, flag_next, err_next;

    always @(posedge clk) begin
        if (reset) begin
            count <= 3'b0;
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            // Update outputs from previous cycle's detection
            disc <= disc_next;
            flag <= flag_next;
            err <= err_next;
            
            // Reset detection signals
            disc_next <= 1'b0;
            flag_next <= 1'b0;
            err_next <= 1'b0;
            
            // Update counter
            if (in) begin
                if (count < 3'b111) count <= count + 1;
            end else begin
                count <= 3'b0;
            end
            
            // Detection logic
            if (count == 3'b101 && !in) begin  // 5 1s followed by 0
                disc_next <= 1'b1;
            end else if (count == 3'b110 && !in) begin  // 6 1s followed by 0
                flag_next <= 1'b1;
            end else if (count == 3'b111) begin  // 7 or more 1s
                err_next <= 1'b1;
            end
        end
    end

endmodule