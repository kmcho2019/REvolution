module TopModule(
    input [254:0] in,
    output [7:0] out
);

    reg [7:0] count;
    reg [7:0] count_next;

    always @(in) begin
        count_next = 8'b0;
        for (int i = 0; i < 15; i++) begin
            reg [4:0] segment_count;
            segment_count = 5'b0;
            for (int j = 0; j < 17; j++) begin
                if (in[i*17 + j]) begin
                    segment_count = segment_count + 1;
                end
            end
            count_next = count_next + {3'b0, segment_count};
        end
    end

    always @(posedge count_next) begin
        count <= count_next;
    end

    assign out = count;

endmodule