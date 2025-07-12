module LIFObuffer (
    input wire [3:0] dataIn,
    input wire RW,
    input wire EN,
    input wire Rst,
    input wire Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

    // Stack memory with valid bits
    reg [3:0] stack [0:3];
    reg [3:0] valid;  // One bit per entry (1=valid, 0=empty)

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset clears all valid bits
            valid <= 4'b0000;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            dataOut <= 4'b0;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Push operation - find first empty slot from top
                if (!valid[3]) begin
                    stack[3] <= dataIn;
                    valid[3] <= 1'b1;
                end
                else if (!valid[2]) begin
                    stack[2] <= dataIn;
                    valid[2] <= 1'b1;
                end
                else if (!valid[1]) begin
                    stack[1] <= dataIn;
                    valid[1] <= 1'b1;
                end
                else if (!valid[0]) begin
                    stack[0] <= dataIn;
                    valid[0] <= 1'b1;
                end
            end
            else if (RW && !EMPTY) begin
                // Pop operation - find first valid slot from top
                if (valid[3]) begin
                    dataOut <= stack[3];
                    valid[3] <= 1'b0;
                end
                else if (valid[2]) begin
                    dataOut <= stack[2];
                    valid[2] <= 1'b0;
                end
                else if (valid[1]) begin
                    dataOut <= stack[1];
                    valid[1] <= 1'b0;
                end
                else if (valid[0]) begin
                    dataOut <= stack[0];
                    valid[0] <= 1'b0;
                end
            end
            
            // Update flags
            EMPTY <= (valid == 4'b0000);
            FULL <= (valid == 4'b1111);
        end
    end

endmodule