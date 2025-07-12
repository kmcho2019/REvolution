module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] curr_state;
reg [2:0] prev_state;

always @(posedge clk) begin
    if (reset) begin
        // Reset state machine to a state equivalent to the water level being low
        curr_state <= 3'b000;
        prev_state <= 3'b000;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1; // Supplemental flow valve open on reset
    end else begin
        prev_state <= curr_state;
        
        // Determine current state based on sensor inputs
        if (s[2]) curr_state <= 3'b111;
        else if (s[1]) curr_state <= 3'b011;
        else if (s[0]) curr_state <= 3'b001;
        else curr_state <= 3'b000;
        
        // Adjust flow rates based on current and previous states
        if (curr_state == 3'b111) begin
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
        end else if (curr_state == 3'b011) begin
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
        end else if (curr_state == 3'b001) begin
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
        end else begin
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
        end
        
        // Control supplemental flow valve (dfr) based on water level change
        if (curr_state > prev_state) begin
            dfr <= 1'b1; // Open supplemental flow valve on increasing water level
        end else begin
            dfr <= 1'b0; // Close supplemental flow valve on decreasing or stable water level
        end
    end
end

endmodule