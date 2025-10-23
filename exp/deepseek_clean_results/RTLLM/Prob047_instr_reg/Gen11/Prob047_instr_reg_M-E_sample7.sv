module instr_reg (
    input clk,
    input rst,
    input [1:0] fetch,
    input [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2,
    output reg valid_out
);

    // Dual-edge triggered registers for parallel capture
    reg [7:0] ins_p1_rise, ins_p1_fall;
    reg [7:0] ins_p2_rise, ins_p2_fall;
    
    // Clock enable signals
    wire p1_enable = fetch[0];
    wire p2_enable = fetch[1];
    
    // Rising edge captures
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1_rise <= 0;
            ins_p2_rise <= 0;
        end else begin
            if (p1_enable) ins_p1_rise <= data;
            if (p2_enable) ins_p2_rise <= data;
        end
    end
    
    // Falling edge captures
    always @(negedge clk or negedge rst) begin
        if (!rst) begin
            ins_p1_fall <= 0;
            ins_p2_fall <= 0;
        end else begin
            if (p1_enable) ins_p1_fall <= data;
            if (p2_enable) ins_p2_fall <= data;
        end
    end
    
    // Output staging registers with validity flag
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            ins <= 0;
            ad1 <= 0;
            ad2 <= 0;
            valid_out <= 0;
        end else begin
            // Select most recent capture for each source
            ins <= fetch[0] ? ins_p1_fall[7:5] : ins_p1_rise[7:5];
            ad1 <= fetch[0] ? ins_p1_fall[4:0] : ins_p1_rise[4:0];
            ad2 <= fetch[1] ? ins_p2_fall : ins_p2_rise;
            
            // Validity flag indicates stable outputs
            valid_out <= |fetch;
        end
    end

endmodule