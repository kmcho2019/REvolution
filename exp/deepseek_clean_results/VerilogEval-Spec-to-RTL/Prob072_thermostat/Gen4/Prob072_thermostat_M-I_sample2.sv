module TopModule (
    input  clk,       // Clock for registered outputs
    input  mode,      // 1=heating, 0=cooling
    input  too_cold,  // Temperature too low
    input  too_hot,   // Temperature too high  
    input  fan_on,    // Manual fan request
    output reg heater, // Registered heater control
    output reg aircon, // Registered air conditioner control
    output reg fan     // Registered fan control
);

    // Combinational logic
    wire heater_comb = mode & too_cold;
    wire aircon_comb = ~mode & too_hot;
    wire fan_comb = heater_comb | aircon_comb | fan_on;

    // Sequential logic with clock gating
    always @(posedge clk) begin
        heater <= heater_comb;
        aircon <= aircon_comb;
        fan <= fan_comb;
    end

endmodule