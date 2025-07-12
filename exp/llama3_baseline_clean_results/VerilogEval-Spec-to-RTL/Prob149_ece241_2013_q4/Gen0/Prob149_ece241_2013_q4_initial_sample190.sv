module TopModule(
    input  clk,
    input  reset,
    input  [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [2:0] curr_state;
reg [2:0] next_state;
reg prev_low;

always @(*)
begin
    case (curr_state)
        3'b111: // above the highest sensor
        begin
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b0;
            dfr = 1'b0;
            if (~s[2])
                next_state = s[1] ? 3'b011 : s[0] ? 3'b001 : 3'b000;
            else
                next_state = 3'b111;
        end
        3'b011: // between the highest and middle sensors
        begin
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b1;
            if (prev_low)
                dfr = 1'b1;
            else
                dfr = 1'b0;
            if (~s[1])
                next_state = s[0] ? 3'b001 : 3'b000;
            else if (s[2])
                next_state = 3'b111;
            else
                next_state = 3'b011;
        end
        3'b001: // between the middle and lowest sensors
        begin
            fr2 = 1'b0;
            fr1 = 1'b1;
            fr0 = 1'b1;
            if (prev_low)
                dfr = 1'b1;
            else
                dfr = 1'b0;
            if (~s[0])
                next_state = 3'b000;
            else if (s[1])
                next_state = 3'b011;
            else
                next_state = 3'b001;
        end
        3'b000: // below the lowest sensor
        begin
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = 1'b1;
            if (s[0])
                next_state = 3'b001;
            else
                next_state = 3'b000;
        end
        default: // invalid state
        begin
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b0;
            dfr = 1'b0;
            next_state = 3'b000;
        end
    endcase
end

always @(posedge clk or posedge reset)
begin
    if (reset)
    begin
        curr_state <= 3'b000;
        prev_low <= 1'b1;
    end
    else
    begin
        curr_state <= next_state;
        if ((curr_state == 3'b000) && (next_state != 3'b000))
            prev_low <= 1'b1;
        else if ((curr_state != 3'b000) && (next_state == 3'b000))
            prev_low <= 1'b0;
        else
            prev_low <= prev_low;
    end
end

endmodule