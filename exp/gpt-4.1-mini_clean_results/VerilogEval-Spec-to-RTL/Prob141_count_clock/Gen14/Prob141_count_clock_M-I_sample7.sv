module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // Seconds BCD digits: units (0-9), tens (0-5)
    reg [3:0] sec_u;
    reg [3:0] sec_t;

    // Minutes BCD digits: units (0-9), tens (0-5)
    reg [3:0] min_u;
    reg [3:0] min_t;

    // Hours BCD digits: units (0-9), tens (0-1), range 01 to 12
    reg [3:0] hr_u;
    reg [3:0] hr_t;

    // Internal signals for carries
    wire sec_u_carry, sec_t_carry;
    wire min_u_carry, min_t_carry;
    wire hr_u_carry, hr_t_carry;

    // Seconds units digit carry: increment when sec_u is 9 and increments
    assign sec_u_carry = (sec_u == 4'd9);

    // Seconds tens digit carry: increment when sec_t is 5 and sec_u_carry
    assign sec_t_carry = sec_u_carry && (sec_t == 4'd5);

    // Minutes units digit carry: increment when min_u is 9 and increments
    assign min_u_carry = (min_u == 4'd9);

    // Minutes tens digit carry: increment when min_t is 5 and min_u_carry
    assign min_t_carry = min_u_carry && (min_t == 4'd5);

    // Hours units digit carry logic: hours count from 01 to 12 in BCD
    // Carry when hour is 12 (hr_t=1, hr_u=2)
    assign hr_u_carry = ((hr_t == 4'd1) && (hr_u == 4'd2));

    // Hours tens digit carry: Not used, hours only 01-12

    always @(posedge clk) begin
        if (reset) begin
            pm      <= 1'b0;     // AM
            sec_u   <= 4'd0;
            sec_t   <= 4'd0;
            min_u   <= 4'd0;
            min_t   <= 4'd0;
            hr_u    <= 4'd2;     // 12 hours BCD
            hr_t    <= 4'd1;
        end else if (ena) begin
            // Increment seconds units
            if (sec_u == 4'd9) begin
                sec_u <= 4'd0;
                // Increment seconds tens
                if (sec_t == 4'd5) begin
                    sec_t <= 4'd0;
                    // Increment minutes units
                    if (min_u == 4'd9) begin
                        min_u <= 4'd0;
                        // Increment minutes tens
                        if (min_t == 4'd5) begin
                            min_t <= 4'd0;
                            // Increment hours BCD from 01 to 12
                            if (hr_u == 4'd9) begin
                                hr_u <= 4'd0;
                                // Should never happen since max is 12
                                hr_t <= hr_t + 4'd1;
                            end else if (hr_u == 4'd2 && hr_t == 4'd1) begin
                                // At 12 -> roll over to 01, toggle PM
                                hr_u <= 4'd1;
                                hr_t <= 4'd0;
                                pm <= ~pm;
                            end else begin
                                // Increment hour units digit (normal case)
                                if (hr_u == 4'd9) begin
                                    hr_u <= 4'd0;
                                    hr_t <= hr_t + 4'd1;
                                end else begin
                                    hr_u <= hr_u + 4'd1;
                                end
                            end
                        end else begin
                            min_t <= min_t + 4'd1;
                        end
                    end else begin
                        min_u <= min_u + 4'd1;
                    end
                end else begin
                    sec_t <= sec_t + 4'd1;
                end
            end else begin
                sec_u <= sec_u + 4'd1;
            end
        end
    end

    // Directly assign outputs from registers; all are valid BCD digits
    always @(posedge clk) begin
        // To keep outputs stable synchronous with counters
        hh <= {hr_t, hr_u};
        mm <= {min_t, min_u};
        ss <= {sec_t, sec_u};
    end

endmodule