module TopModule(
    input        clk,
    input        reset,
    input  [2:0] s,
    output reg   fr2,
    output reg   fr1,
    output reg   fr0,
    output reg   dfr
);

    // Define water level states encoding
    localparam L0 = 2'd0; // Below s[0]
    localparam L1 = 2'd1; // Between s[1] and s[0]
    localparam L2 = 2'd2; // Between s[2] and s[1]
    localparam L3 = 2'd3; // Above s[2]

    reg [1:0] current_level, previous_level;

    // Function to decode sensors into water level
    function [1:0] decode_level;
        input [2:0] sensor;
        begin
            // Priority from highest sensor down to lowest:
            // According to problem:
            // s==111 -> L3
            // s[2]=0,s[1]=1 -> L2
            // s[1]=0,s[0]=1 -> L1
            // no sensors asserted -> L0
            // Other patterns map to closest lower level
            if (sensor == 3'b111)
                decode_level = L3;
            else if (sensor[2] == 0 && sensor[1] == 1)
                decode_level = L2;
            else if (sensor[1] == 0 && sensor[0] == 1)
                decode_level = L1;
            else
                decode_level = L0; // Treat all other as lowest level
        end
    endfunction

    // State update on clock
    always @(posedge clk) begin
        if (reset) begin
            // On reset, assume lowest level with max valves open
            current_level  <= L0;
            previous_level <= L0;
        end else begin
            // Update previous level with current before change
            previous_level <= current_level;
            current_level  <= decode_level(s);
        end
    end

    // Output combinational logic based on current and previous level
    always @(*) begin
        if (reset) begin
            // On reset all valves open
            fr0 = 1'b1;
            fr1 = 1'b1;
            fr2 = 1'b1;
            dfr = 1'b1;
        end else begin
            // Nominal flows
            case (current_level)
                L3: begin
                    fr0 = 1'b0;
                    fr1 = 1'b0;
                    fr2 = 1'b0;
                end
                L2: begin
                    fr0 = 1'b1;
                    fr1 = 1'b0;
                    fr2 = 1'b0;
                end
                L1: begin
                    fr0 = 1'b1;
                    fr1 = 1'b1;
                    fr2 = 1'b0;
                end
                L0: begin
                    fr0 = 1'b1;
                    fr1 = 1'b1;
                    fr2 = 1'b1;
                end
                default: begin
                    fr0 = 1'b0;
                    fr1 = 1'b0;
                    fr2 = 1'b0;
                end
            endcase

            // Supplemental flow valve: open if rising level
            // rising means current_level > previous_level
            dfr = (current_level > previous_level) ? 1'b1 : 1'b0;
        end
    end

endmodule