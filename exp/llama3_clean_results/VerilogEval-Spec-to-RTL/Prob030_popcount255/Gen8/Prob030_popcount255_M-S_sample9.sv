module TopModule(
    input [254:0] in,
    output [7:0] out
);

    reg [7:0] count;

    always @(in) begin
        count = 8'b0;
        for (int i = 0; i < 15; i++) begin
            reg [4:0] segment_count;
            segment_count = 5'b0;
            for (int j = 0; j < 17; j++) begin
                segment_count = segment_count + in[i*17 + j];
            end
            count = count + {3'b0, segment_count};
        end
    end

    assign out = count;

endmodule