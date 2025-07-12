module TopModule(clk, d, q);
    input clk;
    input d;
    output q;

    reg q_rising, q_falling;
    reg prev_clk;

    initial begin
        prev_clk = 0;
        q_rising = 0;
        q_falling = 0;
    end

    always @(posedge clk) begin
        q_rising <= d;
    end

    always @(negedge clk) begin
        q_falling <= d;
    end

    always @(posedge clk or negedge clk) begin
        if (clk != prev_clk) begin // clock edge detected
            if (clk == 1'b1) begin // rising edge
                q <= q_rising;
            end else begin // falling edge
                q <= q_falling;
            end
        end
        prev_clk <= clk; // update previous clock value
    end
endmodule