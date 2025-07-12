module TopModule(
    input         clk,
    input         reset,
    input  [2:0]  s,
    output        fr2,
    output        fr1,
    output        fr0,
    output        dfr
);

    reg [2:0] prev_s;

    // Count number of sensors asserted for water level ranking (0 to 3)
    function [1:0] sensor_count;
        input [2:0] sensors;
        begin
            sensor_count = sensors[0] + sensors[1] + sensors[2];
        end
    endfunction

    reg fr2_reg, fr1_reg, fr0_reg, dfr_reg;

    always @(posedge clk) begin
        if (reset) begin
            prev_s  <= 3'b000;
            fr0_reg <= 1'b1;
            fr1_reg <= 1'b1;
            fr2_reg <= 1'b1;
            dfr_reg <= 1'b1;
        end else begin
            prev_s <= s;

            // Nominal flow valves according to sensor pattern
            case (s)
                3'b111: begin // above s[2]
                    fr0_reg <= 1'b0;
                    fr1_reg <= 1'b0;
                    fr2_reg <= 1'b0;
                end
                3'b011: begin // between s[2] and s[1]
                    fr0_reg <= 1'b1;
                    fr1_reg <= 1'b0;
                    fr2_reg <= 1'b0;
                end
                3'b001: begin // between s[1] and s[0]
                    fr0_reg <= 1'b1;
                    fr1_reg <= 1'b1;
                    fr2_reg <= 1'b0;
                end
                3'b000: begin // below s[0]
                    fr0_reg <= 1'b1;
                    fr1_reg <= 1'b1;
                    fr2_reg <= 1'b1;
                end
                default: begin // other patterns treated as below s[0]
                    fr0_reg <= 1'b1;
                    fr1_reg <= 1'b1;
                    fr2_reg <= 1'b1;
                end
            endcase

            // dfr asserted if water level is rising (more sensors asserted than before)
            dfr_reg <= (sensor_count(s) > sensor_count(prev_s)) ? 1'b1 : 1'b0;
        end
    end

    assign fr0 = fr0_reg;
    assign fr1 = fr1_reg;
    assign fr2 = fr2_reg;
    assign dfr = dfr_reg;

endmodule