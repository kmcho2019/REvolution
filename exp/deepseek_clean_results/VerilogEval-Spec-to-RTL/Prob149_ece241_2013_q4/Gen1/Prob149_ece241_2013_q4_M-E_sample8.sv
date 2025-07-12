module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    reg [2:0] sensor_history;
    wire sensors_changed = (sensor_history != s);
    wire level_rising;
    
    // Track highest previously active sensor
    always @(posedge clk) begin
        if (reset) begin
            sensor_history <= 3'b000; // Start with all sensors inactive
        end else if (sensors_changed) begin
            sensor_history <= s;
        end
    end
    
    // Determine if level is rising (previous was lower)
    assign level_rising = sensors_changed && 
                         ((s[2] && !sensor_history[2]) ||  // Rising above s[2]
                          (s[1] && !sensor_history[1]) ||  // Rising above s[1]
                          (s[0] && !sensor_history[0]));   // Rising above s[0]
    
    // Output logic - combinatorial based on current sensors
    assign fr0 = reset ? 1'b1 : !(&s);                     // On unless all sensors active
    assign fr1 = reset ? 1'b1 : !(s[1] || s[2]);           // On if below s[1]
    assign fr2 = reset ? 1'b1 : !(|s);                     // On only if no sensors active
    assign dfr = reset ? 1'b1 : level_rising;              // Supplemental flow when rising
    
endmodule