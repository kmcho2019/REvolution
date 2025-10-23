module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Divide the input vector into 16 groups of 16 bits
    wire [15:0] group [15:0];
    genvar i;
    generate
        for (i = 0; i < 16; i++) begin
            assign group[i] = in[(i*16)+15:(i*16)];
        end
    endgenerate

    // Hierarchical selection process
    wire [3:0] group_sel = sel[7:4]; // Select which group
    wire [3:0] bit_sel = sel[3:0]; // Select which bit within the group

    // Select one group
    wire [15:0] selected_group;
    assign selected_group = group[group_sel];

    // Use a case statement to select the final bit
    always @(*) begin
        case (bit_sel)
            4'd0: out = selected_group[0];
            4'd1: out = selected_group[1];
            4'd2: out = selected_group[2];
            4'd3: out = selected_group[3];
            4'd4: out = selected_group[4];
            4'd5: out = selected_group[5];
            4'd6: out = selected_group[6];
            4'd7: out = selected_group[7];
            4'd8: out = selected_group[8];
            4'd9: out = selected_group[9];
            4'd10: out = selected_group[10];
            4'd11: out = selected_group[11];
            4'd12: out = selected_group[12];
            4'd13: out = selected_group[13];
            4'd14: out = selected_group[14];
            4'd15: out = selected_group[15];
            default: out = 1'b0; // default value
        endcase
    end

endmodule