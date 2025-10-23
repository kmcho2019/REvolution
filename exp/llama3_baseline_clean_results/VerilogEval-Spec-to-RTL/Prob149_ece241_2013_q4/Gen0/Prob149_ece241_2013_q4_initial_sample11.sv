module TopModule(
    input  clk,
    input  reset,
    input  [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    reg [2:0] previous_state;

    always @(*) begin
        if (s == 3'b111) begin // water level above s[2]
            fr0 = 1'b0;
            fr1 = 1'b0;
            fr2 = 1'b0;
            dfr = 1'b0;
        end else if (s == 3'b110) begin // water level between s[2] and s[1]
            fr0 = 1'b1;
            fr1 = 1'b0;
            fr2 = 1'b0;
            if ((previous_state == 3'b001) || (previous_state == 3'b000)) begin
                dfr = 1'b1;
            end else begin
                dfr = 1'b0;
            end
        end else if (s == 3'b100) begin // water level between s[1] and s[0]
            fr0 = 1'b1;
            fr1 = 1'b1;
            fr2 = 1'b0;
            if ((previous_state == 3'b000)) begin
                dfr = 1'b1;
            end else begin
                dfr = 1'b0;
            end
        end else if (s == 3'b000) begin // water level below s[0]
            fr0 = 1'b1;
            fr1 = 1'b1;
            fr2 = 1'b1;
            dfr = 1'b1;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            previous_state <= 3'b000;
        end else begin
            previous_state <= s;
        end
    end

endmodule