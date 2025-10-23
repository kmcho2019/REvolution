module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    // Step 1: Unpack input into 256 4-bit elements
    wire [3:0] in_array [0:255];

    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : input_unpack
            assign in_array[i] = in[i*4 +: 4];
        end
    endgenerate

    // Step 2: Implement four 64-to-1 muxes selected by sel[5:0]
    wire [3:0] stage1_out [0:3]; // Outputs of each 64-to-1 mux

    genvar j;
    generate
        for (j = 0; j < 4; j = j + 1) begin : stage1_muxes
            // Each 64-to-1 mux selects among in_array[j*64 +: 64]
            reg [3:0] mux64_out;
            integer k;
            always @(*) begin
                mux64_out = 4'b0;
                case (sel[5:0])
                    default: mux64_out = in_array[j*64 + sel[5:0]];
                endcase
            end
            assign stage1_out[j] = mux64_out;
        end
    endgenerate

    // Step 3: Final 4-to-1 mux selected by sel[7:6]
    reg [3:0] final_out;
    always @(*) begin
        case (sel[7:6])
            2'b00: final_out = stage1_out[0];
            2'b01: final_out = stage1_out[1];
            2'b10: final_out = stage1_out[2];
            2'b11: final_out = stage1_out[3];
            default: final_out = 4'b0;
        endcase
    end

    assign out = final_out;

endmodule