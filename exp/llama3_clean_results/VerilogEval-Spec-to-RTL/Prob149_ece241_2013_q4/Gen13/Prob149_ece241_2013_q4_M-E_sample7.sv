module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] prev_s; // Previous state of the sensors

// Priority encoder to encode sensor inputs
always @(*) begin
    case (s)
        3'b111: begin
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
        end
        3'b110: begin
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
        end
        3'b101: begin
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
        end
        3'b100: begin
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
        end
        3'b011: begin
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
        end
        3'b010: begin
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
        end
        3'b001: begin
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
        end
        default: begin
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
        end
    endcase
end

// Determine 'dfr' signal based on previous and current state of sensors
always @(posedge clk) begin
    if (reset) begin
        prev_s <= 3'b000;
        dfr <= 1'b1;
    end else begin
        prev_s <= s;
        if ((s > prev_s) && (s != 3'b111)) begin
            dfr <= 1'b1;
        end else begin
            dfr <= 1'b0;
        end
    end
end

// Reset logic
always @(posedge clk) begin
    if (reset) begin
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end
end

endmodule