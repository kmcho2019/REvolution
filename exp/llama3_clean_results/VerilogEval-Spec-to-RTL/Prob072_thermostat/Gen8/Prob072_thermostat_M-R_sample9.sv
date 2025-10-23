module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output logic heater,
    output logic aircon,
    output logic fan
);

    always_comb begin
        heater = (mode && too_cold) ? 1'b1 : 1'b0;
        aircon = (~mode && too_hot) ? 1'b1 : 1'b0;
        fan = ((mode && too_cold) || (~mode && too_hot) || fan_on) ? 1'b1 : 1'b0;
    end

endmodule