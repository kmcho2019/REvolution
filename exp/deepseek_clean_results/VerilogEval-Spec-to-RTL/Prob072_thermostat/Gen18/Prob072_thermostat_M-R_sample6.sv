module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    reg r_heater, r_aircon;
    
    always @(*) begin
        case (mode)
            1'b1: begin // Heating mode
                r_heater = too_cold;
                r_aircon = 1'b0;
            end
            1'b0: begin // Cooling mode
                r_heater = 1'b0;
                r_aircon = too_hot;
            end
        endcase
    end

    assign heater = r_heater;
    assign aircon = r_aircon;
    assign fan = fan_on | r_heater | r_aircon;

endmodule