module TopModule(
    input [254:0] in,
    output [7:0] out
);

    reg [7:0] count;
    reg [4:0] segment_count;
    reg [7:0] temp_count;

    always @(posedge clk) begin
        count <= 8'b0;
        temp_count <= 8'b0;
    end

    always @(in) begin
        for (int i = 0; i < 15; i++) begin
            segment_count = 5'b0;
            for (int j = 0; j < 17; j++) begin
                segment_count = segment_count + in[i*17 + j];
            end
            temp_count = temp_count + {3'b0, segment_count};
        end
        count = temp_count;
    end

    assign out = count;

endmodule