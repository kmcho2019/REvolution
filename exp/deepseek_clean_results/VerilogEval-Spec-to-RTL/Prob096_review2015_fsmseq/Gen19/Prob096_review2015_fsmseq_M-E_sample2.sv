module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [1:0] match_counter;
    reg found;

    always @(posedge clk) begin
        if (reset) begin
            match_counter <= 2'b0;
            found <= 1'b0;
        end else if (!found) begin
            case (match_counter)
                2'b00: match_counter <= (data == 1'b1) ? 2'b01 : 2'b00;
                2'b01: match_counter <= (data == 1'b1) ? 2'b10 : 2'b00;
                2'b10: match_counter <= (data == 1'b0) ? 2'b11 : 2'b00;
                2'b11: begin
                    if (data == 1'b1) found <= 1'b1;
                    match_counter <= 2'b00;
                end
            endcase
        end
    end

    assign start_shifting = found;

endmodule