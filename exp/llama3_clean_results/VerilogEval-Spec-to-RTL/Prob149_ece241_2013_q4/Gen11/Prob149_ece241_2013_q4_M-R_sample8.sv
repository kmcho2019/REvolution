module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] prev_s; // Register to store previous sensor state

// Combinational logic to determine next state
always @(posedge clk) begin
    if (reset) begin
        // Reset to state equivalent to low water level
        prev_s <= 3'b000;
    end else begin
        // Store previous sensor state
        prev_s <= s;
    end
end

// Combinational logic to determine output signals (fr2, fr1, fr0)
always @(*) begin
    case (s)
        3'b000: begin // Water level below the lowest sensor
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
        end
        3'b001: begin // Water level between the lowest and middle sensors
            fr2 = 1'b0;
            fr1 = 1'b1;
            fr0 = 1'b1;
        end
        3'b011: begin // Water level between the middle and highest sensors
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b1;
        end
        default: begin // Water level above the highest sensor
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b0;
        end
    endcase
end

// Combinational logic to determine supplemental flow rate (dfr) signal
always @(*) begin
    if ((s > prev_s) && (s != 3'b000)) begin
        dfr = 1'b1;
    end else begin
        dfr = 1'b0;
    end
end

endmodule