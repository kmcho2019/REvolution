module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // State encoding for time
    typedef enum logic [4:0] {
        IDLE,
        S1, S2, S3, S4, S5, S6, S7, S8, S9, S10,
        M1, M2, M3, M4, M5, M6, M7, M8, M9, M10,
        H1, H2, H3, H4, H5, H6, H7, H8, H9, H10, H11, H12
    } time_state_t;

    time_state_t current_state, next_state;
    reg pm_reg;
    reg [7:0] hh_reg, mm_reg, ss_reg;

    // Pre-computed BCD values for hours (ROM-like)
    function [7:0] hour_to_bcd;
        input [3:0] hour;
        begin
            case (hour)
                4'd1:  hour_to_bcd = 8'h01;
                4'd2:  hour_to_bcd = 8'h02;
                4'd3:  hour_to_bcd = 8'h03;
                4'd4:  hour_to_bcd = 8'h04;
                4'd5:  hour_to_bcd = 8'h05;
                4'd6:  hour_to_bcd = 8'h06;
                4'd7:  hour_to_bcd = 8'h07;
                4'd8:  hour_to_bcd = 8'h08;
                4'd9:  hour_to_bcd = 8'h09;
                4'd10: hour_to_bcd = 8'h10;
                4'd11: hour_to_bcd = 8'h11;
                4'd12: hour_to_bcd = 8'h12;
                default: hour_to_bcd = 8'h12;
            endcase
        end
    endfunction

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            pm_reg <= 0;
            hh_reg <= 8'h12;
            mm_reg <= 8'h00;
            ss_reg <= 8'h00;
        end else if (ena) begin
            current_state <= next_state;
            
            // Update outputs based on state
            case (next_state)
                S1: ss_reg <= 8'h01;
                S2: ss_reg <= 8'h02;
                S3: ss_reg <= 8'h03;
                S4: ss_reg <= 8'h04;
                S5: ss_reg <= 8'h05;
                S6: ss_reg <= 8'h06;
                S7: ss_reg <= 8'h07;
                S8: ss_reg <= 8'h08;
                S9: ss_reg <= 8'h09;
                S10: ss_reg <= 8'h10;
                M1: begin ss_reg <= 8'h00; mm_reg <= 8'h01; end
                M2: mm_reg <= 8'h02;
                M3: mm_reg <= 8'h03;
                M4: mm_reg <= 8'h04;
                M5: mm_reg <= 8'h05;
                M6: mm_reg <= 8'h06;
                M7: mm_reg <= 8'h07;
                M8: mm_reg <= 8'h08;
                M9: mm_reg <= 8'h09;
                M10: mm_reg <= 8'h10;
                H1: begin mm_reg <= 8'h00; hh_reg <= hour_to_bcd(1); end
                H2: hh_reg <= hour_to_bcd(2);
                H3: hh_reg <= hour_to_bcd(3);
                H4: hh_reg <= hour_to_bcd(4);
                H5: hh_reg <= hour_to_bcd(5);
                H6: hh_reg <= hour_to_bcd(6);
                H7: hh_reg <= hour_to_bcd(7);
                H8: hh_reg <= hour_to_bcd(8);
                H9: hh_reg <= hour_to_bcd(9);
                H10: hh_reg <= hour_to_bcd(10);
                H11: begin 
                    hh_reg <= hour_to_bcd(11);
                    pm_reg <= ~pm_reg;
                end
                H12: hh_reg <= hour_to_bcd(12);
                default: begin
                    ss_reg <= 8'h00;
                    mm_reg <= 8'h00;
                    hh_reg <= hour_to_bcd(12);
                end
            endcase
        end
    end

    // Next state logic
    always_comb begin
        next_state = current_state;
        case (current_state)
            IDLE: next_state = S1;
            S1: next_state = S2;
            S2: next_state = S3;
            S3: next_state = S4;
            S4: next_state = S5;
            S5: next_state = S6;
            S6: next_state = S7;
            S7: next_state = S8;
            S8: next_state = S9;
            S9: next_state = S10;
            S10: next_state = M1;
            M1: next_state = M2;
            M2: next_state = M3;
            M3: next_state = M4;
            M4: next_state = M5;
            M5: next_state = M6;
            M6: next_state = M7;
            M7: next_state = M8;
            M8: next_state = M9;
            M9: next_state = M10;
            M10: next_state = H1;
            H1: next_state = H2;
            H2: next_state = H3;
            H3: next_state = H4;
            H4: next_state = H5;
            H5: next_state = H6;
            H6: next_state = H7;
            H7: next_state = H8;
            H8: next_state = H9;
            H9: next_state = H10;
            H10: next_state = H11;
            H11: next_state = H12;
            H12: next_state = S1;
        endcase
    end

    assign pm = pm_reg;
    assign hh = hh_reg;
    assign mm = mm_reg;
    assign ss = ss_reg;

endmodule