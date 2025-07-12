module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] water_level;
reg [2:0] prev_water_level;

always @(posedge clk) begin
    if (reset) begin
        water_level <= 3'b000;
        prev_water_level <= 3'b000;
    end else begin
        prev_water_level <= water_level;
        if (s == 3'b111) begin
            water_level <= 3'b111;
        end else if (s == 3'b000) begin
            water_level <= 3'b000;
        end else if (s == 3'b001) begin
            water_level <= 3'b001;
        end else if (s == 3'b010) begin
            water_level <= 3'b010;
        end else if (s == 3'b011) begin
            water_level <= 3'b011;
        end else if (s == 3'b100) begin
            water_level <= 3'b100;
        end else if (s == 3'b110) begin
            water_level <= 3'b110;
        end
    end
end

always @(*) begin
    if (water_level == 3'b111) begin
        fr2 <= 1'b0;
        fr1 <= 1'b0;
        fr0 <= 1'b0;
    end else if (water_level == 3'b000) begin
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
    end else if (water_level == 3'b001) begin
        fr2 <= 1'b0;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
    end else if (water_level == 3'b010) begin
        fr2 <= 1'b0;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
    end else if (water_level == 3'b011) begin
        fr2 <= 1'b0;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
    end else if (water_level == 3'b100) begin
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
    end else if (water_level == 3'b110) begin
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
    end
end

always @(*) begin
    if (water_level > prev_water_level) begin
        dfr <= 1'b1;
    end else begin
        dfr <= 1'b0;
    end
end

endmodule