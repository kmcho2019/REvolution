// Define the barrel_shifter module
module barrel_shifter(
    input [7:0] in,   // 8-bit input to be shifted
    input [2:0] ctrl, // 3-bit control signal
    output [7:0] out   // 8-bit shifted output
);

    // Use a combination of LUTs and ALUs to achieve efficient shifting
    wire [7:0] shifted_out;

    // Divide the 8-bit input into 2-bit chunks
    wire [1:0] chunk0 = in[1:0];
    wire [1:0] chunk1 = in[3:2];
    wire [1:0] chunk2 = in[5:4];
    wire [1:0] chunk3 = in[7:6];

    // Use LUTs to generate the shifted output for each chunk
    wire [1:0] shifted_chunk0;
    wire [1:0] shifted_chunk1;
    wire [1:0] shifted_chunk2;
    wire [1:0] shifted_chunk3;

    // ALU to handle the concatenation of the shifted chunks
    wire [7:0] concatenated_out;

    // Use a lookup table to generate the shifted output for each chunk
    always @(*) begin
        case (ctrl)
            3'b000: begin
                shifted_chunk0 = chunk0;
                shifted_chunk1 = chunk1;
                shifted_chunk2 = chunk2;
                shifted_chunk3 = chunk3;
            end
            3'b001: begin
                shifted_chunk0 = {chunk0[0], 1'b0};
                shifted_chunk1 = {chunk1[0], 1'b0};
                shifted_chunk2 = {chunk2[0], 1'b0};
                shifted_chunk3 = {chunk3[0], 1'b0};
            end
            3'b010: begin
                shifted_chunk0 = {chunk0[0], chunk0[1], 1'b0};
                shifted_chunk1 = {chunk1[0], chunk1[1], 1'b0};
                shifted_chunk2 = {chunk2[0], chunk2[1], 1'b0};
                shifted_chunk3 = {chunk3[0], chunk3[1], 1'b0};
            end
            3'b011: begin
                shifted_chunk0 = {chunk0[0], chunk0[1], 1'b0, 1'b0};
                shifted_chunk1 = {chunk1[0], chunk1[1], 1'b0, 1'b0};
                shifted_chunk2 = {chunk2[0], chunk2[1], 1'b0, 1'b0};
                shifted_chunk3 = {chunk3[0], chunk3[1], 1'b0, 1'b0};
            end
            3'b100: begin
                shifted_chunk0 = {chunk0[0], chunk0[1], chunk0[0], 1'b0};
                shifted_chunk1 = {chunk1[0], chunk1[1], chunk1[0], 1'b0};
                shifted_chunk2 = {chunk2[0], chunk2[1], chunk2[0], 1'b0};
                shifted_chunk3 = {chunk3[0], chunk3[1], chunk3[0], 1'b0};
            end
            default: begin
                shifted_chunk0 = chunk0;
                shifted_chunk1 = chunk1;
                shifted_chunk2 = chunk2;
                shifted_chunk3 = chunk3;
            end
        endcase
    end

    // Concatenate the shifted chunks
    assign concatenated_out = {shifted_chunk3, shifted_chunk2, shifted_chunk1, shifted_chunk0};

    // Assign the final output
    assign out = concatenated_out;

endmodule