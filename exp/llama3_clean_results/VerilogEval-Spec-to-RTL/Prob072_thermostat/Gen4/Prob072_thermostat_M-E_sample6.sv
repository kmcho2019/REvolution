module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Define the priority encoding scheme
    wire [1:0] priority;
    assign priority = (mode && too_cold) ? 2'b01 :
                       (~mode && too_hot) ? 2'b10 :
                       fan_on ? 2'b11 : 2'b00;

    // Use a priority encoder to generate the outputs
    assign heater = (mode && too_cold);
    assign aircon = (~mode && too_hot);
    assign fan = (priority == 2'b01) || (priority == 2'b10) || (priority == 2'b11);

endmodule