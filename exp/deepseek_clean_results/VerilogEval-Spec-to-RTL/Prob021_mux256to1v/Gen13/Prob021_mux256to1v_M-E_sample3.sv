module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Slice the input into 4 separate 256-bit vectors (one per output bit)
    wire [255:0] bit_slices [3:0];
    
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : bit_slicing
            // Extract bit i from each 4-bit chunk
            assign bit_slices[i] = {
                in[1023-i], in[1019-i], in[1015-i], in[1011-i], in[1007-i], in[1003-i], in[999-i], in[995-i],
                in[991-i], in[987-i], in[983-i], in[979-i], in[975-i], in[971-i], in[967-i], in[963-i],
                in[959-i], in[955-i], in[951-i], in[947-i], in[943-i], in[939-i], in[935-i], in[931-i],
                in[927-i], in[923-i], in[919-i], in[915-i], in[911-i], in[907-i], in[903-i], in[899-i],
                in[895-i], in[891-i], in[887-i], in[883-i], in[879-i], in[875-i], in[871-i], in[867-i],
                in[863-i], in[859-i], in[855-i], in[851-i], in[847-i], in[843-i], in[839-i], in[835-i],
                in[831-i], in[827-i], in[823-i], in[819-i], in[815-i], in[811-i], in[807-i], in[803-i],
                in[799-i], in[795-i], in[791-i], in[787-i], in[783-i], in[779-i], in[775-i], in[771-i],
                in[767-i], in[763-i], in[759-i], in[755-i], in[751-i], in[747-i], in[743-i], in[739-i],
                in[735-i], in[731-i], in[727-i], in[723-i], in[719-i], in[715-i], in[711-i], in[707-i],
                in[703-i], in[699-i], in[695-i], in[691-i], in[687-i], in[683-i], in[679-i], in[675-i],
                in[671-i], in[667-i], in[663-i], in[659-i], in[655-i], in[651-i], in[647-i], in[643-i],
                in[639-i], in[635-i], in[631-i], in[627-i], in[623-i], in[619-i], in[615-i], in[611-i],
                in[607-i], in[603-i], in[599-i], in[595-i], in[591-i], in[587-i], in[583-i], in[579-i],
                in[575-i], in[571-i], in[567-i], in[563-i], in[559-i], in[555-i], in[551-i], in[547-i],
                in[543-i], in[539-i], in[535-i], in[531-i], in[527-i], in[523-i], in[519-i], in[515-i],
                in[511-i], in[507-i], in[503-i], in[499-i], in[495-i], in[491-i], in[487-i], in[483-i],
                in[479-i], in[475-i], in[471-i], in[467-i], in[463-i], in[459-i], in[455-i], in[451-i],
                in[447-i], in[443-i], in[439-i], in[435-i], in[431-i], in[427-i], in[423-i], in[419-i],
                in[415-i], in[411-i], in[407-i], in[403-i], in[399-i], in[395-i], in[391-i], in[387-i],
                in[383-i], in[379-i], in[375-i], in[371-i], in[367-i], in[363-i], in[359-i], in[355-i],
                in[351-i], in[347-i], in[343-i], in[339-i], in[335-i], in[331-i], in[327-i], in[323-i],
                in[319-i], in[315-i], in[311-i], in[307-i], in[303-i], in[299-i], in[295-i], in[291-i],
                in[287-i], in[283-i], in[279-i], in[275-i], in[271-i], in[267-i], in[263-i], in[259-i],
                in[255-i], in[251-i], in[247-i], in[243-i], in[239-i], in[235-i], in[231-i], in[227-i],
                in[223-i], in[219-i], in[215-i], in[211-i], in[207-i], in[203-i], in[199-i], in[195-i],
                in[191-i], in[187-i], in[183-i], in[179-i], in[175-i], in[171-i], in[167-i], in[163-i],
                in[159-i], in[155-i], in[151-i], in[147-i], in[143-i], in[139-i], in[135-i], in[131-i],
                in[127-i], in[123-i], in[119-i], in[115-i], in[111-i], in[107-i], in[103-i], in[99-i],
                in[95-i], in[91-i], in[87-i], in[83-i], in[79-i], in[75-i], in[71-i], in[67-i],
                in[63-i], in[59-i], in[55-i], in[51-i], in[47-i], in[43-i], in[39-i], in[35-i],
                in[31-i], in[27-i], in[23-i], in[19-i], in[15-i], in[11-i], in[7-i], in[3-i]
            };
        end
    endgenerate

    // Select one bit from each slice
    assign out[0] = bit_slices[0][sel];
    assign out[1] = bit_slices[1][sel];
    assign out[2] = bit_slices[2][sel];
    assign out[3] = bit_slices[3][sel];

endmodule