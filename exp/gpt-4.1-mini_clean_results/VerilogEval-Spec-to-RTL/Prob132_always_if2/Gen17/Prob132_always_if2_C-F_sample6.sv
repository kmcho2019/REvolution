module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // Internal combinational signals representing desired output logic
    wire shut_off_computer_w;
    wire keep_driving_w;

    // Output high when CPU is overheated, triggers computer shutdown
    assign shut_off_computer_w = cpu_overheated;

    // Continue driving only if not yet arrived and gas tank is not empty
    assign keep_driving_w = (~arrived) & (~gas_tank_empty);

    // Register outputs updated combinationally from wires, preventing latches
    always @(*) begin
        shut_off_computer = shut_off_computer_w;
        keep_driving     = keep_driving_w;
    end

endmodule