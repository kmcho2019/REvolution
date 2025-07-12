module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output wire [2:0] ins,
    output wire [4:0] ad1,
    output wire [7:0] ad2
);

    // Internal registers
    reg [7:0] ins_p1;
    reg [7:0] ins_p2;

    // Single clocked always block for all register updates
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 8'b0;
            ins_p2 <= 8'b0;
        end
        else begin
            // Update ins_p1 only when fetch is 2'b01
            if (fetch == 2'b01)
                ins_p1 <= data;
            
            // Update ins_p2 only when fetch is 2'b10
            if (fetch == 2'b10)
                ins_p2 <= data;
        end
    end

    // Direct output assignments (could be registered if needed)
    assign ins = ins_p1[7:5];
    assign ad1 = ins_p1[4:0];
    assign ad2 = ins_p2;

endmodule