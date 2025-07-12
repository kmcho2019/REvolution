module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

    // Internal registers with power gating control
    reg [7:0] ins_p1, ins_p2;
    reg fetch_active;
    wire clk_gated = clk & fetch_active;

    // Priority encoder for fetch signals
    wire [1:0] prioritized_fetch = fetch[1] ? 2'b10 : 
                                 fetch[0] ? 2'b01 : 2'b00;

    // Dual-edge capture logic
    always @(posedge clk_gated or negedge rst) begin
        if (!rst) begin
            ins_p1 <= 0;
            ins <= 0;
            ad1 <= 0;
        end else if (prioritized_fetch == 2'b01) begin
            ins_p1 <= data;
            // First stage of pipeline - partial decode
            ins <= data[7:5];
            ad1 <= data[4:0];
        end
    end

    always @(negedge clk_gated or negedge rst) begin
        if (!rst) begin
            ins_p2 <= 0;
            ad2 <= 0;
        end else if (prioritized_fetch == 2'b10) begin
            ins_p2 <= data;
            // Second stage of pipeline - full capture
            ad2 <= data;
        end
    end

    // Power management control
    always @(*) begin
        fetch_active = |fetch;
    end

endmodule